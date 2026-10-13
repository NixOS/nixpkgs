# Electron rewrites bundled plugin manifests, so they need a writable copy.
{
  coreutils,
  findutils,
  flock,
  writeShellApplication,
}:

writeShellApplication {
  name = "chatgpt-launcher";

  runtimeInputs = [
    coreutils
    findutils
    flock
  ];

  text = ''
    : "''${CHATGPT_EXECUTABLE:?}"
    : "''${CHATGPT_RESOURCES_SOURCE:?}"
    : "''${CHATGPT_RESOURCES_CACHE_KEY:?}"

    cacheHome="''${XDG_CACHE_HOME:-''${HOME:?XDG_CACHE_HOME and HOME are unset}/.cache}"
    cacheRoot="$cacheHome/chatgpt/bundled-plugins-v2"
    resourcesPath="$cacheRoot/$CHATGPT_RESOURCES_CACHE_KEY"

    mkdir -p "$cacheRoot"
    exec {initLockFd}> "$cacheRoot.lock"
    flock --exclusive "$initLockFd"

    # tmpfiles may remove the directory before its lock is acquired.
    while true; do
      mkdir -p "$resourcesPath"
      if exec {resourcesLockFd}< "$resourcesPath"; then
        flock --shared "$resourcesLockFd"
        [[ "$resourcesPath" -ef "/proc/self/fd/$resourcesLockFd" ]] && break
        exec {resourcesLockFd}>&-
      else
        [[ ! -d "$resourcesPath" ]] || exit 1
      fi
    done

    resourcesAreComplete() {
      [[ -d "$CHATGPT_RESOURCES_SOURCE/plugins" ]] || return 1
      for resource in codex codex-code-mode-host cua_node native rg tectonic; do
        [[ "$resourcesPath/$resource" -ef "$CHATGPT_RESOURCES_SOURCE/$resource" ]] || return 1
      done
      # Check presence, not contents: Electron legitimately edits manifests.
      while IFS= read -r -d "" pluginFile; do
        [[ -f "$resourcesPath/plugins/$pluginFile" ]] || return 1
      done < <(find "$CHATGPT_RESOURCES_SOURCE/plugins" -type f -printf '%P\0')
    }

    if [[ ! -f "$resourcesPath/.complete" ]] || ! resourcesAreComplete; then
      # Repair only with no running app reading or rewriting this resource tree.
      # Do not wait indefinitely for an application to exit while holding initLock.
      if ! flock --exclusive --nonblock "$resourcesLockFd"; then
        echo "ChatGPT bundled-plugin cache needs repair but is in use; close the running app and retry." >&2
        exit 1
      fi
      rm -f "$resourcesPath/.complete"
      ln -sfn -t "$resourcesPath" \
        "$CHATGPT_RESOURCES_SOURCE"/{codex,codex-code-mode-host,cua_node,native,rg,tectonic}
      mkdir -p "$resourcesPath/plugins"
      chmod -R u+w "$resourcesPath/plugins"
      # Restore missing files without overwriting existing mutable manifests.
      cp -RT --update=none --preserve=mode "$CHATGPT_RESOURCES_SOURCE/plugins" "$resourcesPath/plugins"
      chmod -R u+w "$resourcesPath/plugins"
      # An incompatible existing file type cannot be repaired non-destructively.
      if ! resourcesAreComplete; then
        rm -f "$resourcesPath/.complete"
        echo "ChatGPT bundled-plugin cache is incomplete: $resourcesPath" >&2
        exit 1
      fi
      sync --file-system "$resourcesPath"
      touch "$resourcesPath/.complete"
      sync --file-system "$resourcesPath"
      # The launched app retains a shared lock so tmpfiles skips its resources.
      flock --shared "$resourcesLockFd"
    fi
    exec {initLockFd}>&-

    export CODEX_ELECTRON_BUNDLED_PLUGINS_RESOURCES_PATH="$resourcesPath"

    waylandFlags=()
    if [[ -n "''${NIXOS_OZONE_WL:-}" && -n "''${WAYLAND_DISPLAY:-}" ]]; then
      waylandFlags=(
        --ozone-platform=wayland
        --enable-features=WaylandWindowDecorations
        --enable-wayland-ime=true
      )
    fi

    exec "$CHATGPT_EXECUTABLE" "''${waylandFlags[@]}" "$@"
  '';
}
