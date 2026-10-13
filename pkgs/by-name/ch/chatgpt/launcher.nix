# Electron rewrites bundled plugin manifests, so they need a writable copy.
{
  lib,
  coreutils,
  flock,
  writeShellApplication,
}:

writeShellApplication {
  name = "chatgpt-launcher";

  text = ''
    : "''${CHATGPT_EXECUTABLE:?}"
    : "''${CHATGPT_RESOURCES_SOURCE:?}"
    : "''${CHATGPT_RESOURCES_CACHE_KEY:?}"

    cacheHome="''${XDG_CACHE_HOME:-''${HOME:?XDG_CACHE_HOME and HOME are unset}/.cache}"
    cacheRoot="$cacheHome/chatgpt/bundled-plugins-v2"
    resourcesPath="$cacheRoot/$CHATGPT_RESOURCES_CACHE_KEY"

    ${lib.getExe' coreutils "mkdir"} -p "$cacheRoot"
    exec {initLockFd}> "$cacheRoot.lock"
    ${lib.getExe flock} --exclusive "$initLockFd"

    # tmpfiles may remove the directory before its lock is acquired.
    while true; do
      ${lib.getExe' coreutils "mkdir"} -p "$resourcesPath"
      if exec {resourcesLockFd}< "$resourcesPath"; then
        ${lib.getExe flock} --shared "$resourcesLockFd"
        [[ "$resourcesPath" -ef "/proc/self/fd/$resourcesLockFd" ]] && break
        exec {resourcesLockFd}>&-
      else
        [[ ! -d "$resourcesPath" ]] || exit 1
      fi
    done

    if [[ ! -f "$resourcesPath/.complete" ]]; then
      ${lib.getExe' coreutils "ln"} -sfn -t "$resourcesPath" \
        "$CHATGPT_RESOURCES_SOURCE"/{codex,codex-code-mode-host,cua_node,native,rg,tectonic}
      ${lib.getExe' coreutils "mkdir"} -p "$resourcesPath/plugins"
      ${lib.getExe' coreutils "chmod"} -R u+w "$resourcesPath/plugins"
      ${lib.getExe' coreutils "cp"} -RT --preserve=mode "$CHATGPT_RESOURCES_SOURCE/plugins" "$resourcesPath/plugins"
      ${lib.getExe' coreutils "chmod"} -R u+w "$resourcesPath/plugins"
      ${lib.getExe' coreutils "sync"} --file-system "$resourcesPath"
      ${lib.getExe' coreutils "touch"} "$resourcesPath/.complete"
      ${lib.getExe' coreutils "sync"} --file-system "$resourcesPath"
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
