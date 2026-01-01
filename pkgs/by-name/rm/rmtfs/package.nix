{
  stdenv,
  lib,
  fetchFromGitHub,
  udev,
  qrtr,
  qmic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rmtfs";
  version = "1.1.1";

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "linux-msm";
    repo = "rmtfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ehd8SbKNOpyVoF9oc7e5uYmJOHI+Q6woLyvwO8hhKEc=";
=======
    owner = "andersson";
    repo = "rmtfs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-00KOjdkwcAER261lleSl7OVDEAEbDyW9MWxDd0GI8KA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [
    udev
    qrtr
    qmic
  ];

  installFlags = [ "prefix=$(out)" ];

<<<<<<< HEAD
  meta = {
    maintainers = with lib.maintainers; [ matthewcroughan ];
    description = "Qualcomm Remote Filesystem Service";
    homepage = "https://github.com/linux-msm/rmtfs";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.aarch64;
    mainProgram = "rmtfs";
=======
  meta = with lib; {
    maintainers = with maintainers; [ matthewcroughan ];
    description = "Qualcomm Remote Filesystem Service";
    homepage = "https://github.com/linux-msm/rmtfs";
    license = licenses.bsd3;
    platforms = platforms.aarch64;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
