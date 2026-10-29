# Reprodução em VM com store próprio

O ensaio usa QEMU/KVM e NixOS. O disco de fontes do sistema e o disco gravável
da VM são distintos do Nix store do host. Nenhum diretório do host é montado
na VM. As dependências fixadas e os fontes são copiados por SSH, mas o helper
recusa incluir qualquer saída final Arkhe no fecho copiado.

Isso compara builds em dois ambientes do mesmo equipamento físico. Não é
uma auditoria realizada por outro operador ou em outro equipamento.

## Criar a VM

Em Linux, com Nix, SSH e acesso a `/dev/kvm`, execute dentro de `arkhe/`:

```bash
export NIX_CONFIG='experimental-features = nix-command flakes ca-derivations'
workdir=$(mktemp -d)
ssh-keygen -q -t ed25519 -N '' -f "$workdir/id_ed25519"
vm=$(nix build --impure --file checks/repro-vm.nix \
  --argstr flakePath "$PWD" \
  --argstr sshPublicKey "$(cat "$workdir/id_ed25519.pub")" \
  --no-link --print-out-paths)
NIX_DISK_IMAGE="$workdir/repro.qcow2" \
  "$vm/bin/run-arkhe-repro-vm-vm" > "$workdir/console.log" 2>&1 &
```

Aguarde o SSH na porta local 22429. Confira a chave de host apresentada na
primeira conexão; use um arquivo `known_hosts` próprio para o ensaio.

```bash
ssh -i "$workdir/id_ed25519" -p 22429 \
  -o StrictHostKeyChecking=ask -o UserKnownHostsFile="$workdir/known_hosts" \
  root@127.0.0.1 'uname -a; findmnt /nix/.ro-store'
python3 scripts/seed-reproduction-guest.py "$PWD" root@127.0.0.1 \
  --identity-file "$workdir/id_ed25519" --known-hosts-file "$workdir/known_hosts" \
  --evidence-dir "$workdir/evidence"
ssh -i "$workdir/id_ed25519" -p 22429 \
  -o UserKnownHostsFile="$workdir/known_hosts" root@127.0.0.1 \
  'python3 /root/arkhe/scripts/validate-source.py &&
   python3 /root/arkhe/scripts/reproduce-in-guest.py /root/arkhe /root/arkhe/expected-host.json /root/validation'
scp -r -i "$workdir/id_ed25519" -P 22429 \
  -o UserKnownHostsFile="$workdir/known_hosts" root@127.0.0.1:/root/validation "$workdir/"
```

O seed importa dependências locais sem exigir assinatura de cache: o manifesto
registra os caminhos e verifica que o fecho não contém saídas Arkhe. O compilador
e as dependências são comuns aos dois ambientes; os artefatos Arkhe são
compilados separadamente. O guest exige ausência prévia de **todos** os alvos,
desativa substituição de binários e builders remotos, e registra derivação e
hash NAR para cada pacote. O host deve ter construído os alvos antes do seed
para que `expected-host.json` contenha todos os hashes de comparação.

Ao concluir, desligue a VM por SSH com `poweroff`. Preserve o disco e as
evidências se desejar inspecionar o ambiente novamente.

## Comparar os resultados finais

```bash
python3 scripts/compare-reproduction.py "$workdir/evidence/expected-host.json" \
  "$workdir/validation/results.json" > "$workdir/evidence/comparison.json"
```

Se os builds do host e da VM rodaram ao mesmo tempo, atualize os hashes do host no manifesto antes da comparação. O comparador recusa resultados incompletos, substituição de binários e builders remotos.
