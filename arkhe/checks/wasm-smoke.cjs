const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const wasm = require(path.resolve(process.argv[2], 'arkhe_verify.js'));
let accepted = 0;
let rejected = 0;
for (const name of fs.readdirSync(process.argv[3]).filter(n => /^\d+-leaves\.json$/.test(n))) {
  const v = JSON.parse(fs.readFileSync(path.join(process.argv[3], name)));
  for (const p of v.expected_output.proofs) {
    const leaf = Buffer.from(v.input.leaves[p.target_index], 'hex');
    const root = Buffer.from(v.expected_output.root_hash_hex, 'hex');
    const proof = p.inclusion_proof_hashes.map((h, i) => ({
      hash: Array.from(Buffer.from(h, 'hex')),
      kind: p.inclusion_proof_kinds[i], direction: p.inclusion_proof_directions[i]
    }));
    const verify = (l, count, r, pr = proof) => {
      try { return wasm.verify_mmr(l, count, JSON.stringify(pr), r); }
      catch { return false; }
    };
    assert.equal(verify(leaf, v.input.leaf_count, root), true, `${name}/${p.target_index}`);
    accepted++;
    const badRoot = Buffer.from(root); badRoot[0] ^= 1;
    const badLeaf = Buffer.from(leaf); badLeaf[0] ^= 1;
    for (const verdict of [verify(leaf, v.input.leaf_count, badRoot),
      verify(badLeaf, v.input.leaf_count, root), verify(leaf, 0, root)]) {
      assert.equal(verdict, false); rejected++;
    }
    for (let i = 0; i < proof.length; i++) {
      const badProof = structuredClone(proof); badProof[i].hash[0] ^= 1;
      assert.equal(verify(leaf, v.input.leaf_count, root, badProof), false); rejected++;
    }
  }
}
assert(accepted > 0 && rejected > accepted);
assert.equal(wasm.verify_policy_request('{}', '{}'), -1);
console.log(JSON.stringify({ status: 'PASS', accepted, rejected, invalidPolicy: 'rejected' }));
