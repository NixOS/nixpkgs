{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quill-log";
<<<<<<< HEAD
  version = "11.0.2";
=======
  version = "11.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "odygrd";
    repo = "quill";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-b5kHxvjmTea5HU9gTvizFwhG2zwOJSPlf30XKEhxe8w=";
=======
    hash = "sha256-h5vjHyhAVPcVZJFKbXFm2eUbesI088XkA7HZCCx9jzc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/odygrd/quill";
    changelog = "https://github.com/odygrd/quill/blob/master/CHANGELOG.md";
    downloadPage = "https://github.com/odygrd/quill";
    description = "Asynchronous Low Latency C++17 Logging Library";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.odygrd ];
  };
})
