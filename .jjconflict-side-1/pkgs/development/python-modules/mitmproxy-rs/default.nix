{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  mitmproxy,
  mitmproxy-linux,
  mitmproxy-macos,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "mitmproxy-rs";
  version = "0.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "mitmproxy_rs";
    tag = "v${version}";
    hash = "sha256-bWvSaUx5nv8d17eOWyYlhSDi71rHycrFoDGRuQEL7LU=";
  };

  buildAndTestSubdir = "mitmproxy-rs";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-9J5RVGCXyMOcCYUP+LS92Xv1krA+feoMqFgeFExxxqY=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies =
    lib.optionals stdenv.hostPlatform.isLinux [ mitmproxy-linux ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ mitmproxy-macos ];
  # not packaged yet
  # ++ lib.optionals stdenv.hostPlatform.isWindows [ mitmproxy-windows ]

  # repo has no python tests
  doCheck = false;

  pythonImportsCheck = [ "mitmproxy_rs" ];

  meta = with lib; {
    description = "Rust bits in mitmproxy";
    homepage = "https://github.com/mitmproxy/mitmproxy_rs";
    changelog = "https://github.com/mitmproxy/mitmproxy_rs/blob/${src.rev}/CHANGELOG.md#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = licenses.mit;
    inherit (mitmproxy.meta) maintainers;
  };
}
