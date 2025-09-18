{
  lib,
  fetchFromGitHub,
  perl,
  buildPerlModule,
  makeWrapper,
  wrapGAppsHook3,
  withGtk3 ? false,
  ffmpeg,
  mpv,
  wget,
  xdg-utils,
  yt-dlp,
  TestPod,
  Gtk3,
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
buildPerlModule rec {
  pname = "pipe-viewer";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "trizen";
    repo = "pipe-viewer";
    rev = version;
    hash = "sha256-ZcO07zDMXSFOWIC0XHqeqjgPJXzWWh8G2szTkvF8OjM=";
  };

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals withGtk3 [ wrapGAppsHook3 ];

  buildInputs = [
    perlEnv
  ]
  # Can't be in perlEnv for wrapGAppsHook3 to work correctly
  ++ lib.optional withGtk3 Gtk3;

  # Not supported by buildPerlModule
  # and the Perl code fails anyway
  # when Getopt::Long sets $gtk in Build.PL:
  # Modification of a read-only value attempted at /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-perl5.34.0-Getopt-Long-2.52/lib/perl5/site_perl/5.34.0/Getopt/Long.pm line 585.
  #buildFlags = lib.optional withGtk3 "--gtk3";
  postPatch = lib.optionalString withGtk3 ''
    substituteInPlace Build.PL --replace 'my $gtk ' 'my $gtk = 1;#'
  '';

  nativeCheckInputs = [
    TestPod
  ];

  dontWrapGApps = true;

  postInstall = ''
    cp -r share/* $out/share
  '';

  postFixup = ''
    wrapProgram "$out/bin/pipe-viewer" \
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

  meta = with lib; {
    homepage = "https://github.com/trizen/pipe-viewer";
    description = "CLI+GUI YouTube Client";
    license = licenses.artistic2;
    maintainers = with maintainers; [ julm ];
    platforms = platforms.all;
    mainProgram = "pipe-viewer";
  };
}
