{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
}:
buildNpmPackage (finalAttrs: {
  pname = "oscgoesbrrr";
  version = "1.42.0";
  src = fetchFromGitHub {
    owner = "OscToys";
    repo = "OscGoesBrrr";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-KRx8rMsQFU7dYmjO/JCjkUp2JheTkQ8sUT56Q0Q+p8E=";
  };
  npmDepsHash = "sha256-HObRprVAnJWSay8x7+Apkp0sKx1CpnjIB1ze4xks/Lo=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  postInstall = ''
    makeWrapper ${lib.getExe electron} $out/bin/OscGoesBrrr \
      --add-flags $out/lib/node_modules/OscGoesBrrr \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  meta = {
    description = "Make haptics in real life go BRRR from VRChat";
    downloadPage = "https://github.com/OscToys/OscGoesBrrr";
    homepage = "https://osc.toys";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ TheButlah ];
    mainProgram = "OscGoesBrrr";
  };
})
