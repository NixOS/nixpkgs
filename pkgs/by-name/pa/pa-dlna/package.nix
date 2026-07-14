{
  lib,
  curl,
  fetchFromGitLab,
  flac,
  ffmpeg-headless,
  lame,
  pulseaudio,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pa-dlna";
  version = "1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "xdegaye";
    repo = "pa-dlna";
    tag = finalAttrs.version;
    hash = "sha256-f0JGJwenKH/4LQv40AhmpYmzAzqkSUhdTBeB4VzqTaQ=";
  };

  postPatch = ''
    substituteInPlace pa_dlna/encoders.py \
      --replace-fail "shutil.which('ffmpeg')" "'${lib.getExe ffmpeg-headless}'" \
      --replace-fail "shutil.which('flac')" "'${lib.getExe flac}'" \
      --replace-fail "shutil.which('lame')" "'${lib.getExe lame}'"
    substituteInPlace pa_dlna/pa_dlna.py \
      --replace-fail "shutil.which('parec')" "'${lib.getExe' pulseaudio "parec"}'"
    substituteInPlace systemd/pa-dlna.service \
      --replace-fail "/usr/bin/pa-dlna" "$out/bin/pa-dlna"
  '';

  build-system = [ python3.pkgs.flit-core ];

  dependencies = with python3.pkgs; [
    libpulse
    psutil
    systemd-python
  ];

  postInstall = ''
    install systemd/pa-dlna.service -Dt $out/share/systemd/user/
  '';

  nativeCheckInputs = [
    curl
    ffmpeg-headless
    python3.pkgs.pytestCheckHook
  ];

  disabledTests = [
    # path to parec is patched and which breaks the mocking
    "test_no_parec"
  ];

  pythonImportsCheck = [ "pa_dlna" ];

  meta = {
    description = "UPnP control point forwarding PulseAudio streams to DLNA devices";
    homepage = "https://gitlab.com/xdegaye/pa-dlna";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "pa-dlna";
  };
})
