{
  kuma,
  ...
}@args:

kuma.override (
  {
    pname = "kumactl";
    isFull = false;
    components = [ "kumactl" ];
  }
  // removeAttrs args [ "kuma" ]
)
