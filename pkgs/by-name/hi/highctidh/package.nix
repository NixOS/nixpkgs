{
  fetchgit,
  fieldSize ? 2048,
  lib,
  stdenv,
  useAssemblyBackendIfAvailable ? true,
}:
let
  filename = "libhighctidh_${toString fieldSize}.so";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libhighctidh_${toString fieldSize}";
  version = "1.0.2024092800";

  src = fetchgit {
    url = "https://codeberg.org/vula/highctidh.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UStNvXnaFLxL9aiMtxAKB8IbC0qnB6Pw+BObtG1XGKg=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  buildFlags = [ filename ];

  doCheck = true;
  checkTarget = lib.concatStringsSep " " [
    "testrandom"
    "test${toString fieldSize}"
  ];

  installPhase = ''
    $preInstall

    mkdir -p $out/include/libhighctidh
    cp *.h $out/include/libhighctidh

    mkdir -p $out/lib
    cp ${filename} $out/lib

    $postInstall
  '';

  env.${if useAssemblyBackendIfAvailable then null else "HIGHCTIDH_PORTABLE"} = "1";

  meta = with lib; {
    homepage = "https://codeberg.org/vula/highctidh";
    description = "high-ctidh fork as a portable shared library";
    maintainers = with maintainers; [ mightyiam ];
    license = licenses.publicDomain;
  };
})
