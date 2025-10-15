{ stdenv, fetchFromGitea, }:

stdenv.mkDerivation (finalAttrs: {
  pname = "sglauncher";
  version = "1.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ItsZariep";
    repo = "SGLauncher";
    rev = finalAttrs.version;
    hash = "sha256-zIhutvtNA0UJ8+nMWv2t6hMpO9wkYI2sjSNT78ggn58=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.gtk3 ];

  buildPhase = ''
    cd ./src
    ${pkgs.gnumake}/bin/make sglauncher SHELL=${pkgs.bash}/bin/bash
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp sglauncher $out/bin
  '';

  meta = {
    description = "Simple GTK Launcher";
    homepage = "https://codeberg.org/ItsZariep/SGLauncher";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ reylak ];
    mainProgram = "sglauncher";
  })
}
