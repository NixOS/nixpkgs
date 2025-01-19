{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "hashcat-utils";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "hashcat";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wgc6wv7i6cs95rgzzx3zqm14xxbjyajvcqylz8w97d8kk4x4wjr";
  };

  sourceRoot = "${src.name}/src";

  installPhase = ''
    runHook preInstall
    install -Dm0555 *.bin -t $out/bin
    install -Dm0555 *.pl -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Small utilities that are useful in advanced password cracking";
    homepage = "https://github.com/hashcat/hashcat-utils";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fadenb ];
  };
}
