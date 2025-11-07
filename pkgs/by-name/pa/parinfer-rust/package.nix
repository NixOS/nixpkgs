{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages,
}:

rustPlatform.buildRustPackage {
  pname = "parinfer-rust";
  version = "0.4.3-unstable-2024-05-07";

  src = fetchFromGitHub {
    owner = "eraserhd";
    repo = "parinfer-rust";
    rev = "d84828b453e158d06406f6b5e9056f6b54ff76c9";
    sha256 = "sha256-Q2fYogfn5QcNDEie4sUaVydAmDmcFXnsvz35cxPCf+M=";
  };

  cargoHash = "sha256-w/GMjNtKiMGYOfzSl5IZTeHBSp4C9Mu6+oogCqHxdb4=";

  nativeBuildInputs = [
    llvmPackages.clang
    rustPlatform.bindgenHook
  ];

  postInstall = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp rc/parinfer.kak $out/share/kak/autoload/plugins/

    rtpPath=$out/plugin
    mkdir -p $rtpPath
    sed "s,let s:libdir = .*,let s:libdir = '${placeholder "out"}/lib'," \
      plugin/parinfer.vim > $rtpPath/parinfer.vim
  '';

  meta = with lib; {
    description = "Infer parentheses for Clojure, Lisp, and Scheme";
    mainProgram = "parinfer-rust";
    homepage = "https://github.com/eraserhd/parinfer-rust";
    license = licenses.isc;
    maintainers = with maintainers; [ eraserhd ];
  };
}
