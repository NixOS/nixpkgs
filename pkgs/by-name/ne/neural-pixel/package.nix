{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  sd ? stable-diffusion-cpp,
  stable-diffusion-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neural-pixel";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "Luiz-Alcantara";
    repo = "Neural-Pixel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zos/rJLjqGjUaaU0Lg87cYB8QYvMvoHfVSNzcCkcAe4=";
  };

  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace src/cmd_generator.c \
    --replace-fail '		g_ptr_array_add(data->sd_cmd_array, g_strdup("./sd"));' \
    '		g_ptr_array_add(data->sd_cmd_array, g_strdup("${sd}/bin/sd-cli"));'
    substituteInPlace src/widgets_cb.c \
    --replace-fail '		sd_bin = g_strdup("./sd");' \
    '		sd_bin = g_strdup("${sd}/bin/sd-cli");'
    substituteInPlace src/main.c \
    --replace-fail '	gtk_css_provider_load_from_file (css_provider, g_file_new_for_path ("resources/styles.css"));' \
    '	gtk_css_provider_load_from_file (css_provider, g_file_new_for_path ("${placeholder "out"}/share/neural_pixel/styles.css"));'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 bin/neural_pixel $out/bin/neural_pixel
    install -Dm644 resources/styles.css $out/share/neural_pixel/styles.css
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/neural_pixel --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "A simple GUI wrapper for stable-diffusion.cpp written using C and GTK 4";
    homepage = "https://github.com/Luiz-Alcantara/Neural-Pixel";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lethargii ];
    changelog = "https://github.com/Luiz-Alcantara/Neural-Pixel/releases";
    platforms = lib.platforms.linux;
    mainProgram = "neural_pixel";
  };
})
