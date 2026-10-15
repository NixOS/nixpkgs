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

stdenv.mkDerivation (finalAttrs: {
  pname = "fontpreview";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "sdushantha";
    repo = "fontpreview";
    rev = finalAttrs.version;
    hash = "sha256-nETwJ6uLXYsTh+N0eFYzAx1No7kQOJYzQhd6Yc0UcTw=";
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

  meta = {
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
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.erictapen ];
    mainProgram = "fontpreview";
  };
})
