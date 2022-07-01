{ lib
, fetchFromGitHub
, perl
, buildPerlModule
, makeWrapper
, wrapGAppsHook
, withGtk3 ? false
, ffmpeg
, gtk3
, wget
, xdg-utils
, youtube-dl
, yt-dlp
, TestPod
, Gtk3
}:
let
  perlEnv = perl.withPackages (ps: with ps; [
    AnyURIEscape
    DataDump
    Encode
    FilePath
    GetoptLong
    HTTPMessage
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
  ] ++ lib.optionals withGtk3 [
    FileShareDir
  ]);
in
buildPerlModule rec {
  pname = "pipe-viewer";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "trizen";
    repo = "pipe-viewer";
    rev = version;
    hash = "sha256-kDlZ3Cl8zvN/naGExh2yVW5yHwc1O04x4s22lNkbCzU=";
  };

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals withGtk3 [ wrapGAppsHook ];

  buildInputs = [ perlEnv ]
    # Can't be in perlEnv for wrapGAppsHook to work correctly
    ++ lib.optional withGtk3 Gtk3;

  # Not supported by buildPerlModule
  # and the Perl code fails anyway
  # when Getopt::Long sets $gtk in Build.PL:
  # Modification of a read-only value attempted at /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-perl5.34.0-Getopt-Long-2.52/lib/perl5/site_perl/5.34.0/Getopt/Long.pm line 585.
  #buildFlags = lib.optional withGtk3 "--gtk3";
  postPatch = lib.optionalString withGtk3 ''
    substituteInPlace Build.PL --replace 'my $gtk ' 'my $gtk = 1;#'
  '';

  checkInputs = [
    TestPod
  ];

  dontWrapGApps = true;
  postFixup = ''
    wrapProgram "$out/bin/pipe-viewer" \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg wget youtube-dl yt-dlp ]}"
  '' + lib.optionalString withGtk3 ''
    wrapProgram "$out/bin/gtk-pipe-viewer" ''${gappsWrapperArgs[@]} \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg wget xdg-utils youtube-dl yt-dlp ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/trizen/pipe-viewer";
    description = "CLI+GUI YouTube Client";
    license = licenses.artistic2;
    maintainers = with maintainers; [ julm ];
    platforms = platforms.all;
  };
}
