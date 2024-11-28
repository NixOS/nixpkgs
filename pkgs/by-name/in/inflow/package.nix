{ lib, stdenv, fetchFromGitHub, runCommand, inflow, diffutils }:

stdenv.mkDerivation rec {
  pname = "inflow";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "stephen-huan";
    repo = "inflow";
    rev = "v${version}";
    hash = "sha256-xKUqkrPwITai8g6U1NiNieAip/AzISgFfFtvR30hLNk=";
  };

  buildPhase = ''
    runHook preBuild

    $CXX -Wall -Wpedantic -Wextra -O3 -o inflow inflow.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 inflow -t $out/bin

    runHook postInstall
  '';

  passthru.tests = {
    reflowWithLineLength = runCommand "${pname}-test"
      {
        nativeBuildInputs = [ inflow ];
        buildInputs = [ diffutils ];
      } ''
      cat <<EOF > input.txt
      xxxxx xxx xxx xxxx xxxxxxxxx xx x xxxxxxxxx x xxxx xxxx xxxxxxx xxxxxxxx xxx
      xxxxxxxxx xxxxxxxx xx xx xxxxx xxxxx xxxx xx x xxxx xx xxxxxxxx xxxxxxxx xxxx
      xxx xxxx xxxx xxx xxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxx xxx xxxxx xx xxxx x xxxx
      xxxxxxxx xxxx xxxx xx xxxxx xxxx xxxxx xxxx xxxxxxxxx xxx xxxxxxxxxxx xxxxxx
      xxx xxxxxxxxx xxxx xxxx xx x xx xxxx xxx xxxx xx xxx xxx xxxxxxxxxxx xxxx xxxxx
      x xxxxx xxxxxxx xxxxxxx xx xx xxxxxx xx xxxxx
      EOF

      inflow 72 < input.txt > actual.txt

      cat <<EOF > expected.txt
      xxxxx xxx xxx xxxx xxxxxxxxx xx x xxxxxxxxx x xxxx xxxx xxxxxxx
      xxxxxxxx xxx xxxxxxxxx xxxxxxxx xx xx xxxxx xxxxx xxxx xx x xxxx
      xx xxxxxxxx xxxxxxxx xxxx xxx xxxx xxxx xxx xxxxxxxxxxxxxxxxxxx
      xxxxxxxxxxxxx xxx xxxxx xx xxxx x xxxx xxxxxxxx xxxx xxxx xx xxxxx
      xxxx xxxxx xxxx xxxxxxxxx xxx xxxxxxxxxxx xxxxxx xxx xxxxxxxxx
      xxxx xxxx xx x xx xxxx xxx xxxx xx xxx xxx xxxxxxxxxxx xxxx xxxxx
      x xxxxx xxxxxxx xxxxxxx xx xx xxxxxx xx xxxxx
      EOF

      if ! cmp --silent expected.txt actual.txt
      then
        echo "Error: actual.txt and expected.txt are different"
        diff actual.txt expected.txt
        exit 1
      fi

      touch $out
    '';
  };

  meta = with lib; {
    description = "Variance-optimal paragraph formatter";
    homepage = "https://github.com/stephen-huan/inflow";
    license = licenses.unlicense;
    mainProgram = "inflow";
    maintainers = with maintainers; [ fbrs ];
    platforms = platforms.all;
  };
}
