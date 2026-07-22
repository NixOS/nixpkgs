{
  lib,
  stdenv,
  fetchurl,
  mpi,
}:

let
  mpiDev = lib.getDev mpi;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "osu-micro-benchmarks";
  version = "7.5.2";

  src = fetchurl {
    url = "https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${finalAttrs.version}.tar.gz";
    hash = "sha256-YY3j0LESL3OpIpF30toeXNYuQxGQWAy5FfJgWEnLu9w=";
  };

  nativeBuildInputs = [ mpi ];

  buildInputs = [ mpi ];

  configureFlags = [
    "CC=${mpiDev}/bin/mpicc"
    "CXX=${mpiDev}/bin/mpicxx"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/bin
    find $out/libexec -name 'osu_*' -type f -executable | while read -r f; do
      ln -s "$f" "$out/bin/"
    done
  '';

  meta = {
    description = "OSU Micro-Benchmarks for MPI";
    longDescription = ''
      The OSU microbenchmark suite is a collection of independent message passing interface (MPI) performance
      benchmarks. It includes performance measures such as latency, bandwidth, and host overhead.

       Common benchmarks:
       - osu_latency: Point-to-point latency
       - osu_bw: Point-to-point bandwidth
       - osu_bibw: Bidirectional bandwidth
       - osu_allreduce: Collective allreduce
       - osu_alltoall: Collective all-to-all
    '';
    homepage = "https://mvapich.cse.ohio-state.edu/benchmarks/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ spaghetti-stack ];
    mainProgram = "osu_latency";
  };
})
