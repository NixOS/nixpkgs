{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "adapta-backgrounds";
  version = "0.5.3.1";

  src = fetchFromGitHub {
    owner = "adapta-project";
    repo = "adapta-backgrounds";
    rev = version;
    sha256 = "04hmbmzf97rsii8gpwy3wkljy5xhxmlsl34d63s6hfy05knclydj";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ glib ];

  meta = with lib; {
    description = "Wallpaper collection for adapta-project";
    homepage = "https://github.com/adapta-project/adapta-backgrounds";
    license = with licenses; [
      gpl2
      cc-by-sa-40
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
