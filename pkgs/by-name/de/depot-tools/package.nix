{
  bash,
  common-updater-scripts,
  coreutils,
  fetchgit,
  git,
  lib,
  makeWrapper,
  python3,
  stdenvNoCC,
  which,
  writeShellApplication,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      httplib2
      requests
      setuptools
    ]
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "depot-tools";
  version = "unstable-2026-04-29";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromium/tools/depot_tools.git";
    rev = "f2f7ec41f2c170d6f1899406f11a48411760a683";
    hash = "sha256-/4Zz169PVxRGFubknL+5hbUX9uRnOGArjt0dA8u0I88=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace gerrit_util.py \
      --replace-fail "import httplib2.socks" "httplib2.socks = None" \
      --replace-fail "httplib2.socks.socksocket._socksocket__rewriteproxy = __fixed_rewrite_proxy" "pass" \
      --replace-fail "httplib2.socks.PROXY_TYPE_HTTP_NO_TUNNEL" "3"
  '';

  installPhase = ''
    runHook preInstall

    depot_tools="$out/share/depot_tools"
    mkdir -p "$depot_tools" "$out/bin"
    cp -R . "$depot_tools"
    chmod -R u+w "$depot_tools"
    patchShebangs "$depot_tools"

    runtime_path="$depot_tools:${
      lib.makeBinPath [
        bash
        coreutils
        git
        python
        which
      ]
    }"

    while IFS= read -r -d "" tool; do
      name="$(basename "$tool")"
      case "$name" in
        *.bat|*.cmd|*.ps1)
          continue
          ;;
      esac

      if [ -f "$tool" ] && [ -x "$tool" ]; then
        makeWrapper "$tool" "$out/bin/$name" \
          --set DEPOT_TOOLS_DIR "$depot_tools" \
          --set DEPOT_TOOLS_UPDATE 0 \
          --set VPYTHON_BYPASS "manually managed python not supported by chrome operations" \
          --prefix PATH : "$runtime_path"
      fi
    done < <(find "$depot_tools" -maxdepth 1 -type f -perm -0100 -print0)

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-depot-tools";
    runtimeInputs = [
      common-updater-scripts
      git
    ];
    text = ''
      set -euo pipefail

      url="https://chromium.googlesource.com/chromium/tools/depot_tools.git"
      rev="$(git ls-remote "$url" refs/heads/main | cut -f1)"
      tmp="$(mktemp -d)"
      trap 'rm -rf "$tmp"' EXIT

      git -C "$tmp" init -q
      git -C "$tmp" fetch -q --depth=1 "$url" "$rev"
      date="$(git -C "$tmp" show -s --format=%cs FETCH_HEAD)"

      update-source-version depot-tools "unstable-$date" --rev="$rev"
    '';
  });

  meta = {
    description = "Tools for working with Chromium development";
    homepage = "https://www.chromium.org/developers/how-tos/depottools/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "gclient";
    platforms = lib.platforms.unix;
  };
})
