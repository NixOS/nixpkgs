{
  lib,
  fetchFromGitHub,
  perl,
  makeWrapper,
  wrapGAppsHook3,
  withGtk3 ? false,
  ffmpeg,
  mpv,
  wget,
  xdg-utils,
  yt-dlp,
  perlPackages,
}:
let
  perlEnv = perl.withPackages (
    ps:
    with ps;
    [
      AnyURIEscape
      DataDump
      Encode
      FilePath
      GetoptLong
      HTTPMessage
      IOCompress
      IOCompressBrotli
      JSON
      JSONXS
      LWPProtocolHttps
      LWPUserAgentCached
      Memoize
      PathTools
      ScalarListUtils
      TermReadLineGnu
      TextParsewords
      UnicodeLineBreak
    ]
    ++ lib.optionals withGtk3 [
      FileShareDir
    ]
  );
in
perlPackages.buildPerlModule rec {
  pname = "pipe-viewer";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "trizen";
    repo = "pipe-viewer";
    tag = version;
    hash = "sha256-24y/4NfGAyGkn9kUnuEoibkzUPBkgabE/Jp7NUNIHco=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals withGtk3 [ wrapGAppsHook3 ];

  buildInputs = [
    perlEnv
  ]
  # Can't be in perlEnv for wrapGAppsHook3 to work correctly
  ++ lib.optional withGtk3 perlPackages.Gtk3;

  # Not supported by buildPerlModule
  # and the Perl code fails anyway
  # when Getopt::Long sets $gtk in Build.PL:
  # Modification of a read-only value attempted at /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-perl5.34.0-Getopt-Long-2.52/lib/perl5/site_perl/5.34.0/Getopt/Long.pm line 585.
  #buildFlags = lib.optional withGtk3 "--gtk3";
  postPatch = lib.optionalString withGtk3 ''
    substituteInPlace Build.PL --replace 'my $gtk ' 'my $gtk = 1;#'
  '';

  nativeCheckInputs = [
    perlPackages.TestPod
  ];

  dontWrapGApps = true;

  postInstall = ''
    cp -r share/* $out/share
  '';

  postFixup = ''
    wrapProgram "$out/bin/pipe-viewer" \
      --prefix PERL5LIB : "$PERL5LIB" \
      --prefix PATH : "${
        lib.makeBinPath [
          ffmpeg
          mpv
          wget
          yt-dlp
        ]
      }"
  ''
  + lib.optionalString withGtk3 ''
    # make xdg-open overrideable at runtime
    wrapProgram "$out/bin/gtk-pipe-viewer" ''${gappsWrapperArgs[@]} \
      --prefix PERL5LIB : "$PERL5LIB" \
      --prefix PATH : "${
        lib.makeBinPath [
          ffmpeg
          mpv
          wget
          yt-dlp
        ]
      }" \
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"
  '';

  meta = {
    homepage = "https://github.com/trizen/pipe-viewer";
    description = "CLI+GUI YouTube Client";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ julm ];
    platforms = lib.platforms.all;
    mainProgram = "pipe-viewer";
  };
}
