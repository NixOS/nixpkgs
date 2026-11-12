// The NixOS test's client: through the server at the origin given, signs in as the
// administrator the module's configuration bootstraps, agrees to the terms, saves a timeline,
// reads it back, finds its moment in the site-wide search, and downloads it as an .och file
// (made by the packaged och-convert). Exits non-zero, saying why, on any failure.
// Usage: node client.mjs <origin> <username> <password>
import assert from 'node:assert/strict';

const [origin, username, password] = process.argv.slice(2);
const cookies = new Map();
let csrf;
/** A request to the API, keeping cookies and the CSRF token; its JSON, or its bytes. */
async function call(path, data, { method = data ? 'POST' : 'GET', bytes = false } = {}) {
  const res = await fetch(origin + path, {
    method,
    headers: {
      Origin: origin,
      ...(cookies.size ? { Cookie: [...cookies].map(([k, v]) => `${k}=${v}`).join('; ') } : {}),
      ...(csrf ? { 'X-CSRF-Token': csrf } : {}),
      ...(data ? { 'Content-Type': 'application/json' } : {}),
    },
    ...(data ? { body: JSON.stringify(data) } : {}),
  });
  for (const header of res.headers.getSetCookie()) {
    const [key, value] = header.split(';')[0].split('=');
    if (value) cookies.set(key, value);
    else cookies.delete(key);
  }
  if (bytes) {
    assert(res.ok, `${path}: ${res.status}`);
    return Buffer.from(await res.arrayBuffer());
  }
  const value = await res.json();
  assert(res.ok, `${path}: ${res.status} ${JSON.stringify(value)}`);
  csrf = value.csrf ?? csrf;
  return value;
}

await call('/api/session');
await call('/api/auth/login', { username, password });
const session = await call('/api/session');
assert.equal(session.user?.username, username);
assert(session.fileExchange, 'the server converts .och files');
if (session.user.termsRequired) await call('/api/auth/terms', { acceptTerms: session.terms });

const created = await call('/api/timelines', {
  format: 'openchronology',
  version: 1,
  title: 'Lighthouses of NixOS',
  description: 'Saved by the NixOS test.',
  events: [{ id: 'beacon', time: '1/1', metadata: { title: 'First beacon lit' } }],
});
const read = await call(`/api/timelines/${created.id}`);
assert.equal(read.title, 'Lighthouses of NixOS');
// The search rows are written as the timeline is indexed: retried for a while.
let found = [];
for (let attempt = 0; attempt < 30 && !found.length; attempt++) {
  found = (
    await call('/api/timelines/entities/search', { search: 'beacon', scope: 'mine' })
  ).entities;
  if (!found.length) await new Promise((resolve) => setTimeout(resolve, 500));
}
assert.deepEqual(
  found.map((e) => e.title),
  ['First beacon lit'],
);
const file = await call(`/api/timelines/${created.id}/file`, undefined, {
  bytes: true,
});
assert.equal(file.subarray(0, 16).toString('latin1'), 'SQLite format 3\0', 'an .och file');
console.log(`PASS signed in, saved, read, searched and downloaded ${created.id} as .och`);
