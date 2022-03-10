{ stdenv, lib, pkgs, fzf, gawk, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "sway-launcher-desktop";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "Biont";
    repo = "sway-launcher-desktop";
    rev = "v${version}";
    sha256 = "0i19igj30jyszqb63ibq0b0zxzvjw3z1zikn9pbk44ig1c0v61aa";
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
    longDescription = ''
      This is a TUI-based launcher menu made with bash and the amazing fzf.
      Despite its name, it does not (read: no longer) depend on the Sway window manager
      in any way and can be used with just about any WM.
    '';
    homepage = "https://github.com/Biont/sway-launcher-desktop";
    changelog = "https://github.com/Biont/sway-launcher-desktop/releases/tag/v${version}";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.mrhedgehog ];
    mainProgram = "${pname}";
  };
}
