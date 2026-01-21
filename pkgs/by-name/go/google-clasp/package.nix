{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
}:

buildNpmPackage rec {
  pname = "clasp";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "clasp";
    tag = "v${version}";
    hash = "sha256-Pxt3MaDDsk/qq3NSuwG3jOoPthwrL0QelaruoC37hfA=";
  };

  patches = [
    # https://github.com/google/clasp/pull/1112
    (fetchpatch {
      url = "https://github.com/google/clasp/commit/b183d4b5fbdb51f7bc2e3edadf5fd3bbff28bad1.patch";
      hash = "sha256-lnC7DfKsV4E5guxbjZ+WfkLj5wDLYwObPtH21dmFUcc=";
    })
  ];

  npmDepsHash = "sha256-IyFcGcT3ceoaaf2sCPriEIoWPavg+YGsvkxr1MkLj5c=";

  # `npm run build` tries installing clasp globally
  npmBuildScript = [ "compile" ];

  meta = {
    description = "Develop Apps Script Projects locally";
    mainProgram = "clasp";
    homepage = "https://github.com/google/clasp#readme";
    changelog = "https://github.com/google/clasp/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
