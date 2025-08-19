{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  xdotool,
  fzf,
  imagemagick,
  sxiv,
  getopt,
}:

stdenv.mkDerivation rec {
  pname = "fontpreview";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "fontpreview";
    rev = version;
    sha256 = "0g3i2k6n2yhp88rrcf0hp6ils7836db7hx73hw9qnpcbmckz0i4w";
  };

  nativeBuildInputs = [ makeWrapper ];

  preInstall = "mkdir -p $out/bin";

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/fontpreview \
      --prefix PATH : ${
        lib.makeBinPath [
          xdotool
          fzf
          imagemagick
          sxiv
          getopt
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://github.com/sdushantha/fontpreview";
    description = "Highly customizable and minimal font previewer written in bash";
    longDescription = ''
      fontpreview is a commandline tool that lets you quickly search for fonts
      that are installed on your machine and preview them. The fuzzy search
      feature is provided by fzf and the preview is generated with imagemagick
      and then displayed using sxiv. This tool is highly customizable, almost
      all of the variables in this tool can be changed using the commandline
      flags or you can configure them using environment variables.
    '';
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.erictapen ];
    mainProgram = "fontpreview";
  };
}
