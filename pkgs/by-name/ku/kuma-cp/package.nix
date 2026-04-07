{
  kuma,
  isFull ? false,
}:

kuma.override {
  pname = "kuma-cp";
  components = [ "kuma-cp" ];
  inherit
    isFull
    ;
}
