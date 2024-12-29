{ stdenv, croc }:

stdenv.mkDerivation {
  name = "croc-test-local-relay";

  nativeBuildInputs = [ croc ];

  buildCommand = ''
    HOME="$(mktemp -d)"
    # start a local relay
    croc relay --ports 11111,11112 &

    export CROC_SECRET="sN3nx4hGLeihmn8G"

    # start sender in background
    MSG="See you later, alligator!"
    croc --relay localhost:11111 send --code correct-horse-battery-staple --text "$MSG" &

    # wait for things to settle
    sleep 1
    MSG2=$(croc --relay localhost:11111 --yes correct-horse-battery-staple)

    # compare
    [ "$MSG" = "$MSG2" ] && touch $out
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    timeout = 300;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
