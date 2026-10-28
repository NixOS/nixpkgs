import GIRepository from 'gi://GIRepository';

GIRepository.Repository.dup_default().prepend_search_path('@typelibDir@');

export default (await import('./.@originalName@-wrapped.js')).default;
