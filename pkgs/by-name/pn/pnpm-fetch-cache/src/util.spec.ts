import assert from 'node:assert'
import { urlToCachePath } from './util.js'

describe('util', () => {
	describe('#urlToCachePath()', () => {
		it('should handle @types/node@24.10.1', () => {
			assert.equal(
				urlToCachePath(
					'https://registry.npmjs.org/@types/node/-/node-24.10.1.tgz',
				),
				'https/registry.npmjs.org/@types/node/-/node-24.10.1.tgz',
			)
			assert.equal(
				urlToCachePath(
					new URL('https://registry.npmjs.org/@types/node/-/node-24.10.1.tgz'),
				),
				'https/registry.npmjs.org/@types/node/-/node-24.10.1.tgz',
			)
		})
	})
})
