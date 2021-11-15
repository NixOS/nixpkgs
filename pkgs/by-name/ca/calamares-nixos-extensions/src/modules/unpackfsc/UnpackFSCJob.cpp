/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

#include "UnpackFSCJob.h"

#include "FSArchiverRunner.h"
#include "UnsquashRunner.h"

#include <utils/Logger.h>
#include <utils/NamedEnum.h>
#include <utils/Variant.h>

#include <memory>

static const NamedEnumTable< UnpackFSCJob::Type >
typeNames()
{
    using T = UnpackFSCJob::Type;

    static const NamedEnumTable< T > names {
        { "none", T::None },         { "fsarchiver", T::FSArchive }, { "fsarchive", T::FSArchive },
        { "fsa", T::FSArchive },     { "squashfs", T::Squashfs },    { "squash", T::Squashfs },
        { "unsquash", T::Squashfs },
    };

    return names;
}

UnpackFSCJob::UnpackFSCJob( QObject* parent )
    : Calamares::CppJob( parent )
{
}

UnpackFSCJob::~UnpackFSCJob() {}

QString
UnpackFSCJob::prettyName() const
{
    return tr( "Unpack filesystems" );
}

Calamares::JobResult
UnpackFSCJob::exec()
{
    std::unique_ptr< Runner > r;
    switch ( m_type )
    {
    case Type::FSArchive:
        r = std::make_unique< FSArchiverRunner >( m_source, m_destination );
        break;
    case Type::Squashfs:
        r = std::make_unique< UnsquashRunner >( m_source, m_destination );
        break;
    case Type::None:
    default:
        cDebug() << "Nothing to do.";
        return Calamares::JobResult::ok();
    }

    // progress?
    connect( r.get(), &Runner::progress, this, &UnpackFSCJob::progress );
    return r->run();
}

void
UnpackFSCJob::setConfigurationMap( const QVariantMap& map )
{
    QString source = CalamaresUtils::getString( map, "source" );
    QString sourceTypeName = CalamaresUtils::getString( map, "sourcefs" );
    if ( source.isEmpty() || sourceTypeName.isEmpty() )
    {
        cWarning() << "Skipping item with bad source data:" << map;
        return;
    }
    bool bogus = false;
    Type sourceType = typeNames().find( sourceTypeName, bogus );
    if ( sourceType == Type::None )
    {
        cWarning() << "Skipping item with source type None";
        return;
    }
    QString destination = CalamaresUtils::getString( map, "destination" );
    if ( destination.isEmpty() )
    {
        cWarning() << "Skipping item with empty destination";
        return;
    }

    m_source = source;
    m_destination = destination;
    m_type = sourceType;
}

CALAMARES_PLUGIN_FACTORY_DEFINITION( UnpackFSCFactory, registerPlugin< UnpackFSCJob >(); )
