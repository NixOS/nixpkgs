{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libX11,
  libXinerama,
}:

let
  rpathLibs = [
    libXinerama
    libX11
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    tag = version;
    hash = "sha256-3voGKM6MKisc+ZVdZ5sCrs3XVfeRayozIk4SXNjw820=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-i0rMgV1rV9k7j25zoJc1hHXTpTPfDMSOMciJOvInO34=";

  buildInputs = rpathLibs;

  postInstall = ''
    for p in $out/bin/left*; do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $p
    done

    install -D -m 0555 leftwm/doc/leftwm.1 $out/share/man/man1/leftwm.1
  '';

  dontPatchELF = true;

  meta = {
    description = "Tiling window manager for the adventurer";
    homepage = "https://github.com/leftwm/leftwm";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      vuimuich
      yanganto
    ];
    changelog = "https://github.com/leftwm/leftwm/blob/${version}/CHANGELOG.md";
    mainProgram = "leftwm";
  };
}
