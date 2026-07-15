#!/usr/bin/env node
/* Based on ui/app.js from Sshwifty. */
const { subtle } = require('node:crypto')
const sshwiftyURL = 'http://localhost/sshwifty/socket/verify'
const sharedKey = 'rpz2E4QI6uPMLr'
const serverMessage = 'NixOS test'

async function hmac512(secret, data) {
  const key = await subtle.importKey(
    'raw',
    secret,
    { name: 'HMAC', hash: { name: 'SHA-512' } },
    false,
    ['sign', 'verify'],
  )
  return subtle.sign(key.algorithm, key, data)
}

async function getSocketAuthKey(privateKey) {
  const enc = new TextEncoder(),
    rTime = Number(Math.trunc(Date.now() / 100000))
  return new Uint8Array(
    await hmac512(enc.encode(privateKey), enc.encode(rTime)),
  ).slice(0, 32)
}

async function requestAuth(privateKey) {
  const authKey = await getSocketAuthKey(privateKey)
  const h = await fetch(sshwiftyURL, {
    headers: { 'X-Key': btoa(String.fromCharCode.apply(null, authKey)) },
  })
  const serverDate = h.headers.get('Date')
  return {
    result: h.status,
    date: serverDate ? new Date(serverDate) : null,
    text: await h.text(),
  }
}

async function tryInitialAuth() {
  try {
    const result = await requestAuth(sharedKey)
    if (result.date) {
      const serverRespondTime = result.date,
        serverRespondTimestamp = serverRespondTime.getTime(),
        clientCurrent = new Date(),
        clientTimestamp = clientCurrent.getTime(),
        timeDiff = Math.abs(serverRespondTimestamp - clientTimestamp)
      if (timeDiff > 30000) {
        console.log('Time difference between client and server too big.')
        process.exit(1)
      }
    }
    switch (result.result) {
      case 200:
        if (result.text.includes(serverMessage)) {
          console.log('All good.')
          process.exit()
        } else {
          console.log('Server message not found')
          process.exit(1)
        }
        break
      case 403:
        console.log('We need auth.')
        process.exit(1)
        break
      case 0:
        console.log('Timeout?')
        process.exit(1)
        break
      default:
        console.log('wghat')
        process.exit(1)
    }
  } catch {
    console.log('Something went horribly wrong, ouch.')
    process.exit(1)
  }
}

console.log('Testing Sshwifty')
tryInitialAuth()
