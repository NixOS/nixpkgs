{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "px";
  version = "0.11.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "genotrance";
    repo = "px";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iv2B21XMrvDba4XaaD0B7g4wDfDIfKwRuWBpo1RyH1k=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    h11
    keyring
    keyrings-alt
    netaddr
    psutil
    pymcurl
    pyspnego
    python-dotenv
    quickjs-ng
  ];

  nativeCheckInputs = with python3Packages; [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-xdist
    pytest-httpbin
  ];

  # Makes tests fail in all sorts of ways
  dontUsePytestXdist = true;

  preCheck = ''
    export PXBIN=$out/bin/px
    substituteInPlace tests/helpers.py tests/test_network.py \
      --replace-fail 'cmd = f"px' "cmd = f\"$out/bin/px"
  '';

  meta = {
    description = "HTTP proxy server to automatically authenticate through an NTLM proxy";
    longDescription = ''
      An HTTP(s) proxy server that allows applications to authenticate
      through an NTLM or Kerberos proxy server, typically used in
      corporate deployments, without having to deal with the actual
      handshake. Px leverages Windows SSPI or single sign-on and
      automatically authenticates using the currently logged in
      Windows user account. It is also possible to run Px on Windows,
      Linux and MacOS without single sign-on by configuring the
      domain, username and password to authenticate with.

      Px uses libcurl and supports all the authentication mechanisms
      supported by [libcurl](https://curl.se/libcurl/c/CURLOPT_HTTPAUTH.html).
    '';
    mainProgram = "px";
    homepage = "https://github.com/genotrance/px";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luc65r ];
    platforms = lib.platforms.all;
  };
})
