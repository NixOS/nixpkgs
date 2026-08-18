{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  python3,
  bash,
  curl,
  coreutils,
  gnused,
  jq,
  scitokens-cpp,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "htgettoken";
  version = "2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fermitools";
    repo = "htgettoken";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jHKKTnFZ+6LHaB61wi5+Ht6ZHrE4dDqADIMfGWI47oM=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    bash
    curl
    coreutils
    jq
    scitokens-cpp
  ];

  dependencies = with python3.pkgs; [
    gssapi
    paramiko
    urllib3
  ];

  postInstall = ''
    wrapProgram $out/bin/htdecodetoken \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            jq
            scitokens-cpp
          ]
        }
    wrapProgram $out/bin/htdestroytoken \
        --prefix PATH : $out/bin:${
          lib.makeBinPath [
            coreutils
            curl
          ]
        }
    wrapProgram $out/bin/httokensh \
        --prefix PATH : $out/bin:${
          lib.makeBinPath [
            coreutils
            gnused
            jq
          ]
        }
  '';

  meta = {
    description = "Gets OIDC authentication tokens for High Throughput Computing via a Hashicorp vault server ";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/fermitools/htgettoken";
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
