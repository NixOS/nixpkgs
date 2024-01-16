{ lib
, stdenv
, python3
, fetchPypi
, autoPatchelfHook
, libxcrypt-legacy
}:

let
  platformInfo = {
    "x86_64-linux" = {
      platform = "manylinux1_x86_64";
      hash = "sha256-XC13I7fBu9OpBPothe8HS57xCRyRek6MV6iLcLzaBpk=";
    };
    "x86_64-darwin" = {
      platform = "macosx_10_9_universal2";
      hash = "sha256-XYq49h0KVUGLXeu5mfdlONjpRqmmmp4L5mWTweF/8g8=";
    };
  }.${stdenv.system} or (throw "Unsupported platform ${stdenv.system}");
in
python3.pkgs.buildPythonApplication rec {
  pname = "sourcery";
  version = "1.15.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    inherit (platformInfo) platform hash;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [ libxcrypt-legacy ];

  meta = {
    description = "Instantly review and improve your Python code to keep your codebase maintainable";
    homepage = "https://sourcery.ai";
    license = lib.licenses.unfree;
    mainProgram = "sourcery";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
