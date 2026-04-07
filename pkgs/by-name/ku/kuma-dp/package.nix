{
  kuma,
  isFull ? false,
}:

kuma.override {
  pname = "kuma-dp";
  components = [ "kuma-dp" ];
  inherit
    isFull
    ;
}
