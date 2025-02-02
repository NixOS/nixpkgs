{ stdenv, lib, pkgs, fzf, gawk, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "sway-launcher-desktop";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "Biont";
    repo = "sway-launcher-desktop";
    rev = "v${version}";
    hash = "sha256-lv1MLPJsJJjm6RLzZXWEz1JO/4EXTQ8wj225Di+98G4=";
  };

  postPatch = ''
    patchShebangs ${pname}.sh
  '';

  buildInputs = [ fzf gawk ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -d $out/bin
    install ${pname}.sh $out/bin/${pname}
    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${lib.makeBinPath [ gawk fzf ]}
  '';

  meta = with lib; {
    description = "TUI Application launcher with Desktop Entry support.";
    mainProgram = "sway-launcher-desktop";
    longDescription = ''
      This is a TUI-based launcher menu made with bash and the amazing fzf.
      Despite its name, it does not (read: no longer) depend on the Sway window manager
      in any way and can be used with just about any WM.
    '';
    homepage = "https://github.com/Biont/sway-launcher-desktop";
    changelog = "https://github.com/Biont/sway-launcher-desktop/releases/tag/v${version}";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.pyrox0 ];
  };
}
