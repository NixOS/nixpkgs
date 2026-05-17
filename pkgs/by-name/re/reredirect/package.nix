{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reredirect";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "jerome-pouiller";
    repo = "reredirect";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-RHRamDo7afnJ4DlOVAqM8lQAC60YESGSMKa8Io2vcX0=";
  };

  patches = [
    # Fixes gcc-15 build.
    (fetchpatch2 {
      url = "https://github.com/jerome-pouiller/reredirect/commit/b85df395e18d09b54e1fb73dfe344f8f04224a83.patch";
      hash = "sha256-RTzJrgiJGmUf0iVaSvXw/NLwWRTch1aLdDdLp50sAD8=";
    })
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postFixup = ''
    substituteInPlace ${placeholder "out"}/bin/relink \
      --replace "reredirect" "${placeholder "out"}/bin/reredirect"
  '';

  meta = {
    description = "Tool to dynamicly redirect outputs of a running process";
    homepage = "https://github.com/jerome-pouiller/reredirect";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tobim ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
