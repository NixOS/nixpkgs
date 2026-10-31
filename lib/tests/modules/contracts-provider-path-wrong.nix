# `module` is not an option, and `contract` is empty.
{ options, ... }:
{
  contracts.number.providers.wrong = {
    module = options.services.one;
    contract = [ ];
  };
}
