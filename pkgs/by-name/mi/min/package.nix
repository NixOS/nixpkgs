{ lib, buildNimPackage, fetchFromGitHub, openssl, pcre }:

buildNimPackage (finalAttrs: {
  pname = "min";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "h3rald";
    repo = "min";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4coeasFZrbwYQ6FM0ENkh/pPcvN3rCuheUpmHr1f3wM=";
  };

  lockFile = ./lock.json;

  buildInputs = [ openssl pcre ];

  prePatch = ''
    # substitude our code for their code for data
    substituteInPlace min.nimble \
      --replace-fail 'import' "" \
      --replace-warn 'minpkg/core/meta' "" \
      --replace-warn 'pkgVersion' '"${finalAttrs.version}"' \
      --replace-warn 'pkgAuthor' '""' \
      --replace-warn 'pkgDescription' '""' \
      --replace-warn 'pkgName' '"${finalAttrs.pname}"' \

    # remove vendorabilities
    find . -name '*.a' -delete
    find minpkg/lib -name '*.nim' \
      -exec sed 's|{\.passL:.*\.}|discard|g' -i {} \;
  '';

  NIX_LDFLAGS = [ "-lpcre" ];

  meta = {
    description =
      "A functional, concatenative programming language with a minimalist syntax";
    homepage = "https://min-lang.org/";
    changelog = "https://github.com/h3rald/min/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "min";
    maintainers = with lib.maintainers; [ ehmry ];
  };

})
