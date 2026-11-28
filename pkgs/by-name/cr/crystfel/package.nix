{
  lib,
  stdenv,
  fetchFromGitLab,
  hdf5,
  gsl,
  makeWrapper,
  millepede-ii,
  hdf5-external-filter-plugins,
  fdip,
  pinkindexer,
  xgandalf,
  libccp4,
  mosflm,
  meson,
  ninja,
  pandoc,
  pkg-config,
  wrapGAppsHook3,
  flex,
  bison,
  doxygen,
  opencl-headers,
  ncurses,
  msgpack-c,
  fftw,
  zeromq,
  ocl-icd,
  gtk3,
  gdk-pixbuf,
  argp-standalone,
  withGui ? true,
  withBitshuffle ? true,
}:

stdenv.mkDerivation rec {
  pname = "crystfel";
  version = "0.13.0";
  src = fetchFromGitLab {
    owner = "thomas.white";
    repo = "crystfel";
    domain = "gitlab.desy.de";
    rev = version;
    sha256 = "sha256-KYzR0TxhRvsqVPMccZywoCUZEn2ShRmNaT7u56vs/Pw=";
  };
  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    flex
    bison
    doxygen
    opencl-headers
    makeWrapper
  ]
  ++ lib.optionals withGui [ wrapGAppsHook3 ];
  buildInputs = [
    hdf5
    gsl
    ncurses
    msgpack-c
    fftw
    fdip
    zeromq
    ocl-icd
    libccp4
    mosflm
    pinkindexer
    xgandalf
    pandoc
  ]
  ++ lib.optionals withGui [
    gtk3
    gdk-pixbuf
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    argp-standalone
  ]
  ++ lib.optionals withBitshuffle [ hdf5-external-filter-plugins ];

  # CrystFEL calls mosflm by searching PATH for it. We could've create a wrapper script that sets the PATH, but
  # we'd have to do that for every CrystFEL executable (indexamajig, crystfel, partialator). Better to just
  # hard-code mosflm's path once.
  postPatch = ''
    sed -i -e 's#execlp("mosflm"#execl("${mosflm}/bin/mosflm"#' libcrystfel/src/indexers/mosflm.c;
  '';

  postInstall = lib.optionalString withBitshuffle ''
    for file in $out/bin/*; do
      wrapProgram $file \
        --set HDF5_PLUGIN_PATH ${hdf5-external-filter-plugins}/lib/plugins \
        --prefix PATH ":" ${lib.makeBinPath [ millepede-ii ]}
    done
  '';

  meta = {
    description = "Data processing for serial crystallography";
    longDescription = ''
      CrystFEL is a suite of programs for processing (and simulating) Bragg diffraction data from "serial crystallography" experiments, often (but not always) performed using an X-ray Free-Electron Laser. Compared to rotation data, some of the particular characteristics of such data which call for a specialised software suite are:

      - The sliced, rather than integrated, measurement of intensity data. Many, if not all reflections are partially integrated.
      - Many patterns (thousands) are required - high throughput is needed.
      - The crystal orientations in each pattern are random and uncorrelated.
      - Merging into lower symmetry point groups may require the resolution of indexing ambiguities.'';
    homepage = "https://crystfel.pages.desy.de";
    changelog = "https://crystfel.pages.desy.de/changes.html";
    downloadPage = "https://crystfel.pages.desy.de/download.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.unix;
  };

}
