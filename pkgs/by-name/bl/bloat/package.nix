{
  lib,
  buildGoModule,
  fetchgit,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "bloat";
  version = "0-unstable-2024-12-27";

  src = fetchgit {
    url = "git://git.freesoftwareextremist.com/bloat";
    rev = "d171b6c2d50500cdfd2f3308bf82a5f79e22cd8b";
    hash = "sha256-a9nL6NvZLQZLOuoqdDbZTH9dVtQ6guKopkAHughINcg=";
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
