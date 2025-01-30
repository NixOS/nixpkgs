{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  jq,
  mpv,
}:

stdenv.mkDerivation rec {
  pname = "somafm-cli";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "rockymadden";
    repo = "somafm-cli";
    rev = "v${version}";
    sha256 = "1h5p9qsczgfr450sklh2vkllcpzb7nicbs8ciyvkavh3d7hds0yy";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -m0755 -D src/somafm $out/bin/somafm
    wrapProgram $out/bin/somafm --prefix PATH ":" "${
      lib.makeBinPath [
        curl
        jq
        mpv
      ]
    }";
  '';

  meta = with lib; {
    description = "Listen to SomaFM in your terminal via pure bash";
    homepage = "https://github.com/rockymadden/somafm-cli";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "somafm";
  };
}
