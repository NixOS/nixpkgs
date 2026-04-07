{
  kuma,
  isFull ? true,
  enableGateway ? true,
}:

kuma.override {
  pname = "kuma-experimental";
  inherit
    isFull
    enableGateway
    ;
}
