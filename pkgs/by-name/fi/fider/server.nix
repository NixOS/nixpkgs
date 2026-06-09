{
  buildGoModule,

  pname,
  version,
  src,
  vendorHash,
}:

buildGoModule {
  inherit version src vendorHash;
  pname = "${pname}-server";

  patches = [
    ./0001-disable-etc-copy.patch
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false; # requires a running PostgreSQL database

  # preCheck = ''
  #   set -o allexport
  #   source ./.test.env
  #   set +o allexport
  # '';
}
