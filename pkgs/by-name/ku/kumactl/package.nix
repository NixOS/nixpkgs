{
  kuma,
  isFull ? false,
}:

kuma.override {
  pname = "kumactl";
  components = [ "kumactl" ];
  inherit
    isFull
    ;
}
