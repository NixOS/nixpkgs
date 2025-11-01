ignored=(/nix /dev /proc /etc $(if [ -n "$privateTmp" ]; then echo "/tmp"; fi) )
ro_mounts=()
symlinks=()
etc_ignored=()

exec ${extraPreBwrapCmds}

# loop through all entries of root in the fhs environment, except its /etc.
for i in ${fhsenv}/*; do
  path="/${i##*/}"
  if [[ $path == '/etc' ]]; then
    :
  elif [[ -L $i ]]; then
    symlinks+=(--symlink "$(readlink $i)" "$path")
    ignored+=("$path")
  else
    ro_mounts+=(--ro-bind "$i" "$path")
    ignored+=("$path")
  fi
done

# loop through the entries of /etc in the fhs environment.
if [[ -d ${fhsenv}/etc ]]; then
  for i in ${fhsenv}/etc/*; do
    path="/${i##*/}"
    # NOTE: we're binding /etc/fonts and /etc/ssl/certs from the host so we
    # don't want to override it with a path from the FHS environment.
    if [[ $path == '/fonts' || $path == '/ssl' ]]; then
      continue
    fi
    if [[ -L $i ]]; then
      symlinks+=(--symlink "$i" "/etc$path")
    else
      ro_mounts+=(--ro-bind "$i" "/etc$path")
    fi
    etc_ignored+=("/etc$path")
  done
fi

# propagate /etc from the actual host if nested
if [[ -e /.host-etc ]]; then
  ro_mounts+=(--ro-bind /.host-etc /.host-etc)
else
  ro_mounts+=(--ro-bind /etc /.host-etc)
fi

# link selected etc entries from the actual root
for i in ${etcBindEntries[@]}; do
  if [[ "${etc_ignored[@]}" =~ "$i" ]]; then
    continue
  fi
  if [[ -e $i ]]; then
    symlinks+=(--symlink "/.host-etc/${i#/etc/}" "$i")
  fi
done

declare -a auto_mounts
# loop through all directories in the root
for dir in /*; do
  # if it is a directory and it is not ignored
  if [[ -d "$dir" ]] && [[ ! "${ignored[@]}" =~ "$dir" ]]; then
    # add it to the mount list
    auto_mounts+=(--bind "$dir" "$dir")
  fi
done

declare -a x11_args
# Always mount a tmpfs on /tmp/.X11-unix
# Rationale: https://github.com/flatpak/flatpak/blob/be2de97e862e5ca223da40a895e54e7bf24dbfb9/common/flatpak-run.c#L277
x11_args+=(--tmpfs /tmp/.X11-unix)

# Try to guess X socket path. This doesn't cover _everything_, but it covers some things.
if [[ "$DISPLAY" == *:* ]]; then
  # recover display number from $DISPLAY formatted [host]:num[.screen]
  display_nr=${DISPLAY/#*:} # strip host
  display_nr=${display_nr/%.*} # strip screen
  local_socket=/tmp/.X11-unix/X$display_nr
  x11_args+=(--ro-bind-try "$local_socket" "$local_socket")
fi

if [ -n "$privateTmp" ]; then
  # sddm places XAUTHORITY in /tmp
  if [[ "$XAUTHORITY" == /tmp/* ]]; then
    x11_args+=(--ro-bind-try "$XAUTHORITY" "$XAUTHORITY")
  fi

  # dbus-run-session puts the socket in /tmp
  IFS=";" read -ra addrs <<<"$DBUS_SESSION_BUS_ADDRESS"
  for addr in "${addrs[@]}"; do
    [[ "$addr" == unix:* ]] || continue
    IFS="," read -ra parts <<<"${addr#unix:}"
    for part in "${parts[@]}"; do
      printf -v part '%s' "${part//\\/\\\\}"
      printf -v part '%b' "${part//%/\\x}"
      [[ "$part" == path=/tmp/* ]] || continue
      x11_args+=(--ro-bind-try "${part#path=}" "${part#path=}")
    done
  done
fi
ia32cmd=(
    --tmpfs ${ia32Glibc}/etc \
    --symlink /etc/ld.so.conf ${ia32Glibc}/etc/ld.so.conf \
    --symlink /etc/ld.so.cache ${ia32Glibc}/etc/ld.so.cache \
    --ro-bind ${ia32Glibc}/etc/rpc ${ia32Glibc}/etc/rpc \
    --remount-ro ${ia32Glibc}/etc
)
cmd=(
  ${bubblewrap}/bin/bwrap
  --dev-bind /dev /dev
  --proc /proc
  $(if [ -n "$chdirToPwd" ]; then echo "--chdir $(pwd)"; fi)
  $(if [ -n "$unshareUser" ]; then echo "--unshare-user"; fi)
  $(if [ -n "$unshareIpc" ]; then echo "--unshare-ipc"; fi)
  $(if [ -n "$unsharePid" ]; then echo "--unshare-pid"; fi)
  $(if [ -n "$unshareNet" ]; then echo "--unshare-net"; fi)
  $(if [ -n "$unshareUts" ]; then echo "--unshare-uts"; fi)
  $(if [ -n "$unshareCgroup" ]; then echo "--unshare-cgroup"; fi)
  $(if [ -n "$dieWithParent" ]; then echo "--die-with-parent"; fi)
  --ro-bind /nix /nix
  $(if [ -n "$privateTmp" ]; then echo "--tmpfs /tmp"; fi)
  # Our glibc will look for the cache in its own path in `/nix/store`.
  # As such, we need a cache to exist there, because pressure-vessel
  # depends on the existence of an ld cache. However, adding one
  # globally proved to be a bad idea (see #100655), the solution we
  # settled on being mounting one via bwrap.
  # Also, the cache needs to go to both 32 and 64 bit glibcs, for games
  # of both architectures to work.
  --tmpfs ${glibc}/etc \
  --tmpfs /etc \
  --symlink /etc/ld.so.conf ${glibc}/etc/ld.so.conf \
  --symlink /etc/ld.so.cache ${glibc}/etc/ld.so.cache \
  --ro-bind ${glibc}/etc/rpc ${glibc}/etc/rpc \
  --remount-ro ${glibc}/etc \
  --symlink ${realInit} /init \
  $(if [ -n "$isMultiBuild" ]; then echo ${ia32cmd[@]};  fi)
  ${ro_mounts[@]}
  ${symlinks[@]}
  ${auto_mounts[@]}
  ${x11_args[@]}
  ${extraBwrapArgs[@]}
  ${containerInit}
  #the init args often rely on variables like $@
  $(eval "echo $initArgs")
)
exec ${cmd[@]}
