{
  version,
  stdenv,
  fetchurl,
  lib,
  cmake,
  openssl,
  platformAttrs,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hadoop-yarn-containerexecutor";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/hadoop/common/hadoop-${finalAttrs.version}/hadoop-${finalAttrs.version}-src.tar.gz";
    hash = platformAttrs.${stdenv.system}.srcHash;
  };
  sourceRoot =
    "hadoop-${finalAttrs.version}-src/hadoop-yarn-project/hadoop-yarn/"
    + "hadoop-yarn-server/hadoop-yarn-server-nodemanager/src";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];
  cmakeFlags = [ "-DHADOOP_CONF_DIR=/run/wrappers/yarn-nodemanager/etc/hadoop" ];

  installPhase = ''
    mkdir $out
    mv target/var/empty/local/bin $out/
  '';

  meta = with lib; {
    homepage = "https://hadoop.apache.org/";
    description = "Framework for distributed processing of large data sets across clusters of computers";
    license = licenses.asl20;

    longDescription = ''
      The Hadoop YARN Container Executor is a native component responsible for managing the lifecycle of containers
      on individual nodes in a Hadoop YARN cluster. It launches, monitors, and terminates containers, ensuring that
      resources like CPU and memory are allocated according to the policies defined in the ResourceManager.
    '';

    maintainers = with maintainers; [ illustris ];
    platforms = filter (strings.hasSuffix "linux") (attrNames platformAttrs);
  };
})
