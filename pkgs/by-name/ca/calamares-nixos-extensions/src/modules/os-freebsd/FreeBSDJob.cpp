/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   SPDX-FileCopyrightText: 2019 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *   License-Filename: LICENSE
 */

#include "FreeBSDJob.h"

#include "CalamaresVersion.h"
#include "GlobalStorage.h"
#include "JobQueue.h"
#include "utils/Logger.h"

#include <QDateTime>
#include <QProcess>
#include <QThread>


FreeBSDJob::FreeBSDJob( QObject* parent )
    : Calamares::CppJob( parent )
{
}


FreeBSDJob::~FreeBSDJob() {}


QString
FreeBSDJob::prettyName() const
{
    return tr( "FreeBSD Installation Job" );
}

Calamares::JobResult
FreeBSDJob::exec()
{
    emit progress( 0.1 );
    cDebug() << "[FREEBSD]";

    Calamares::JobQueue::instance()->globalStorage()->debugDump();
    emit progress( 0.5 );

    QThread::sleep( 3 );
    emit progress( 1.0 );

    return Calamares::JobResult::ok();
}


void
FreeBSDJob::setConfigurationMap( const QVariantMap& configurationMap )
{
    // TODO: actually fetch something from that configuration
    m_configurationMap = configurationMap;
}

CALAMARES_PLUGIN_FACTORY_DEFINITION( FreeBSDJobFactory, registerPlugin< FreeBSDJob >(); )
