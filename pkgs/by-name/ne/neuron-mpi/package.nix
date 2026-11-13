{
  neuron,
  ...
}@args:

neuron.override (
  {
    useMpi = true;
  }
  // removeAttrs args [ "neuron" ]
)
