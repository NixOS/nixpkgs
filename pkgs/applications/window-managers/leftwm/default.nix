{ lib
, fetchFromGitHub
, rustPlatform
, libX11
, libXinerama
}:

let
  rpathLibs = [ libXinerama libX11 ];
in

rustPlatform.buildRustPackage rec {
  pname = "leftwm";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm";
    rev = "refs/tags/${version}";
    hash = "sha256-hxiSmWf907bVOnzDO5A9dhJWDI8iLoUQII+MyjBE5M0=";
  };

  cargoHash = "sha256-qYnTcAhUG1DnHyATU0dHx2FYalmRcs1PrkC4A2hacxs=";

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
    maintainers = with lib.maintainers; [ vuimuich yanganto ];
    changelog = "https://github.com/leftwm/leftwm/blob/${version}/CHANGELOG.md";
    mainProgram = "leftwm";
  };
}
