{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qrtr,
  systemdLibs,
  lib,
  fetchpatch,
}:
stdenv.mkDerivation {
  pname = "qcom-diag";
  version = "unstable-2026-04-18";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "diag";
    rev = "23c12c167e93215853af4e59c021551767f6fec8";
    hash = "sha256-rDtXNYwXzd29iTv6ZXobX7WfTRruT6jGT7TQUIgiZPY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # https://github.com/linux-msm/diag/pull/25
    (fetchpatch {
      name = "ssid-null-deref.patch";
      url = "https://github.com/linux-msm/diag/commit/809dcac76b534f5908437bc096e3712be4cf26a8.patch";
      hash = "sha256-NCiUlwP5/SJ1Zp17+nADccSysAof5MfqEe1MRTuNB/c=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    qrtr
    systemdLibs
  ];

  installFlags = [
    "prefix=/"
    "DESTDIR=$(out)"
  ];

  meta = {
    maintainers = with lib.maintainers; [ matthewcroughan ];
    description = "Routing of diagnostics related messages between host and various Qualcomm subsystems";
    homepage = "https://github.com/linux-msm/diag";
    license = lib.licenses.bsd3;
    platforms = [
      "aarch64-linux"
    ];
  };
}
