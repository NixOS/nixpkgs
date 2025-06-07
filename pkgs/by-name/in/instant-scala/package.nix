{
  lib,
  stdenv,
  fetchFromGitHub,
  scala-cli,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "instant-scala";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jatcwang";
    repo = "instant-scala";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "jqSvKTL8NzqjwqDj/+55YWecx2bnzuArP8RdfH5q/1U=";
  };

  buildInputs = [
    scala-cli
  ];

  installPhase = ''
    install -Dm755 instant-scala $out/bin/instant-scala
  '';

  meta = {
    description = "Write Scala scripts that starts instantly using scala-cli and GraalVM";
    homepage = "https://github.com/jatcwang/instant-scala";
    changelog = "https://github.com/jatcwang/instant-scala/releases/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jatcwang ];
    mainProgram = "instant-scala";
  };
})
