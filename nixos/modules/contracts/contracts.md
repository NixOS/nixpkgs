# Contracts {#module-contracts}

The contracts wrapper exposes `config.contracts.<type>` and `config.contractTypes` to NixOS, seeded with the contract types defined in `lib.contracts`. Through these options, services declare typed `request`/`result` interfaces and providers register implementations, decoupling consumers from any particular implementation.

For motivation, the consumer/provider patterns, provider selection, chaining, cross-node usage, and how to add a new contract type, see the [Contracts](#contracts) chapter in *Development*.
