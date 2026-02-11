{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxcb-keysyms,
  python3,
  pkg-config,
  cairo,
  expat,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "wmfocus";
    rev = "v${version}";
    sha256 = "sha256-94MgE2j8HaS8IyzHEDtoqTls2A8xD96v2iAFx9XfMcw=";
  };

  cargoHash = "sha256-tYzJS/ApjGuvNnGuBEVr54AGcEmDhG9HtirZvtmNslY=";

  nativeBuildInputs = [
    python3
    pkg-config
  ];
  buildInputs = [
    cairo
    expat
    libxkbcommon
    libxcb-keysyms
  ];

  # For now, this is the only available featureset. This is also why the file is
  # in the i3 folder, even though it might be useful for more than just i3
  # users.
  buildFeatures = [ "i3" ];

  meta = {
    description = "Visually focus windows by label";
    mainProgram = "wmfocus";
    homepage = "https://github.com/svenstaro/wmfocus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ synthetica ];
    platforms = lib.platforms.linux;
  };
}
