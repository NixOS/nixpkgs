import assert from 'node:assert'
import { defaultRegistry, registryUrlForPackage } from './registry.js'

describe('registry', () => {
	describe('registryUrlForPackage()', () => {
		it('should handle scoped packages', () => {
			assert.equal(
				registryUrlForPackage('@types/node@24.10.1'),
				`${defaultRegistry}/@types/node/-/node-24.10.1.tgz`,
			)
			assert.equal(
				registryUrlForPackage('@pnpm/foo.bar@12.34.56-beta.1'),
				`${defaultRegistry}/@pnpm/foo.bar/-/foo.bar-12.34.56-beta.1.tgz`,
			)
		})
		it('should handle unscoped packages', () => {
			assert.equal(
				registryUrlForPackage('typescript@1.2.3'),
				`${defaultRegistry}/typescript/-/typescript-1.2.3.tgz`,
			)
			assert.equal(
				registryUrlForPackage('date-fns@0.0.0-beta.0'),
				`${defaultRegistry}/date-fns/-/date-fns-0.0.0-beta.0.tgz`,
			)
		})
		it('should handle pinned tarball', () => {
			assert.equal(
				registryUrlForPackage('foobar@https://example.com/foobar-1.2.3.tgz'),
				`https://example.com/foobar-1.2.3.tgz`,
			)
			assert.equal(
				registryUrlForPackage(
					'foobar@https://user:pass@private.example.com/foobar-1.2.3.tgz',
				),
				`https://user:pass@private.example.com/foobar-1.2.3.tgz`,
			)
		})
	})
})
