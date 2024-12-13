{
  lib,
  buildGoModule,
  fetchgit,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "bloat";
  version = "0-unstable-2024-10-28";

  src = fetchgit {
    url = "git://git.freesoftwareextremist.com/bloat";
    rev = "68d7acc2f7266c47001445229ff235546c8c71b4";
    hash = "sha256-VLyL1tnb3/qsDFp8s84XTj1Ohl/ajD+tn7V8iBp3ppY=";
  };

  vendorHash = null;

  postInstall = ''
    mkdir -p $out/share/bloat
    cp -r templates $out/share/bloat/templates
    cp -r static $out/share/bloat/static
    sed \
      -e "s%=templates%=$out/share/bloat/templates%g" \
      -e "s%=static%=$out/share/bloat/static%g"       \
      < bloat.conf > $out/share/bloat/bloat.conf.example
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Web client for Pleroma and Mastodon";
    longDescription = ''
      A lightweight web client for Pleroma and Mastodon.
      Does not require JavaScript to display text, images, audio and videos.
    '';
    homepage = "https://bloat.freesoftwareextremist.com";
    downloadPage = "https://git.freesoftwareextremist.com/bloat/";
    license = licenses.cc0;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "bloat";
  };
}
