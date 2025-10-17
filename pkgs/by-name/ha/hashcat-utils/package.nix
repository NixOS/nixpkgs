{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hashcat-utils";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "hashcat";
    repo = "hashcat-utils";
    rev = "v${version}";
    sha256 = "sha256-S2aRNTJMQO/YXdCHexKQ+gZnZp2vGvsvhD5O7t3tfhw=";
  };

  sourceRoot = "${src.name}/src";

  installPhase = ''
    runHook preInstall
    install -Dm0555 *.bin -t $out/bin
    install -Dm0555 *.pl -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Small utilities that are useful in advanced password cracking";
    homepage = "https://github.com/hashcat/hashcat-utils";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fadenb ];
  };
}
